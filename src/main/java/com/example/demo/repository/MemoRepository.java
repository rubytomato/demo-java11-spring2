package com.example.demo.repository;

import com.example.demo.entity.Memo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface MemoRepository extends JpaRepository<Memo, Long> {
  List<Memo> findByDescriptionLikeOrderByIdDesc(String description);

  @Query("SELECT m FROM Memo m WHERE m.updated >= :f AND m.updated < :e")
  List<Memo> findByUpdatedWithMonth(@Param("f") LocalDateTime f, @Param("e") LocalDateTime e);

}
