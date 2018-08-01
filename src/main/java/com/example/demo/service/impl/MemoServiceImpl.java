package com.example.demo.service.impl;

import com.example.demo.entity.Memo;
import com.example.demo.repository.MemoRepository;
import com.example.demo.service.MemoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Slf4j
public class MemoServiceImpl implements MemoService {

  private final MemoRepository memoRepository;

  public MemoServiceImpl(MemoRepository memoRepository) {
    this.memoRepository = memoRepository;
  }

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public Optional<Memo> findById(Long id) {
    return memoRepository.findById(id);
  }

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public Page<Memo> findAll(Pageable page) {
    return memoRepository.findAll(page);
  }

  @Transactional(timeout = 10)
  @Override
  public void update(Memo memo) {
    memoRepository.findById(memo.getId())
        .ifPresentOrElse(m -> m.merge(memo), () -> log.info("memo id:{} not found", memo.getId()));
  }

  @Transactional(timeout = 10)
  @Override
  public void store(Memo memo) {
    memoRepository.save(memo);
  }

  @Transactional(timeout = 10)
  @Override
  public void done(Long id) {
    Optional<Memo> memo = memoRepository.findById(id);
    memo.ifPresentOrElse(m -> m.setDone(true), () -> {
      log.info("memo id:{} not found", id);
    });
  }

  @Transactional(timeout = 10)
  @Override
  public void removeById(Long id) {
    memoRepository.deleteById(id);
  }

}
