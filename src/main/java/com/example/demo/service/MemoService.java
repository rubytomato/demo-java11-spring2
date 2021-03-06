package com.example.demo.service;

import com.example.demo.entity.Memo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface MemoService {
  Optional<Memo> findById(Long id);

  Page<Memo> findAll(Pageable page);

  List<Memo> findByDescriptionLike(String description);

  List<Memo> find(Boolean done);

  List<Memo> findByUpdated(LocalDateTime f, LocalDateTime e);

  void store(Memo memo);

  void done(Long id);

  void updateById(Long id, Memo memo);

  void removeById(Long id);
}
