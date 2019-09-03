package com.example.demo.service.impl;

import com.example.demo.entity.Memo;
import com.example.demo.repository.MemoRepository;
import com.example.demo.service.MemoService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.hibernate.jpa.QueryHints;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@Slf4j
public class MemoServiceImpl implements MemoService {

  private final MemoRepository memoRepository;
  private final EntityManager entityManager;

  public MemoServiceImpl(MemoRepository memoRepository, EntityManager entityManager) {
    this.memoRepository = memoRepository;
    this.entityManager = entityManager;
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

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public List<Memo> findByDescriptionLike(String description) {
    return memoRepository.findByDescriptionLikeOrderByIdDesc(description);
  }

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public List<Memo> findByUpdated(LocalDateTime f, LocalDateTime e) {
    return memoRepository.findByUpdatedWithMonth(f, e);
  }

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public List<Memo> find(Boolean done) {
    try (Stream<Memo> stream = entityManager.createQuery("SELECT m FROM Memo m WHERE m.done = :done ORDER BY m.updated ASC", Memo.class)
        .setParameter("done", done)
        .setHint(QueryHints.HINT_FETCH_SIZE, 10)
        .getResultStream()) {
      return stream.limit(5).collect(Collectors.toList());
    }
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
    memo.ifPresentOrElse(m -> m.setDone(true), () -> log.info("memo id:{} not found", id));
  }

  @Transactional(timeout = 10)
  @Override
  public void updateById(Long id, Memo memo) {
    memoRepository.findById(id)
        .ifPresentOrElse(m -> m.merge(memo), () -> log.info("memo id:{} not found", id));
  }

  @Transactional(timeout = 10)
  @Override
  public void removeById(Long id) {
    memoRepository.deleteById(id);
  }

  @Override
  public String toString() {
    return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
  }

}
