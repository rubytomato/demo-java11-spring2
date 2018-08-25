package com.example.demo.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "memo")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Memo implements Serializable {

  private static final long serialVersionUID = 6722502492897390144L;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "title", nullable = false)
  private String title;
  @Column(name = "description", nullable = false)
  private String description;
  @Column(name = "done", nullable = false)
  private Boolean done;
  @Column(name = "updated", nullable = false)
  private LocalDateTime updated;

  public static Memo of(String title, String description) {
    return Memo.of(null, title, description);
  }

  public static Memo of(Long id, String title, String description) {
    return Memo.builder()
        .id(id)
        .title(title)
        .description(description)
        .done(false)
        .updated(LocalDateTime.now())
        .build();
  }

  public void merge(Memo modifiedMemo) {
    if (modifiedMemo.title != null && modifiedMemo.title.length() > 0) {
      title = modifiedMemo.title;
    }
    if (modifiedMemo.description != null && modifiedMemo.description.length() > 0) {
      description = modifiedMemo.description;
    }
    if (modifiedMemo.done != null) {
      done = modifiedMemo.done;
    }
  }

  @PrePersist
  private void prePersist() {
    done = false;
    updated = LocalDateTime.now();
  }

  @PreUpdate
  private void preUpdate() {
    updated = LocalDateTime.now();
  }

}
