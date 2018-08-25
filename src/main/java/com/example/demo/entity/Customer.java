package com.example.demo.entity;

import com.example.demo.type.Gender;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "customer")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString(exclude = {"customerOrders", "customerReviews"})
public class Customer {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "nick_name", nullable = false)
  private String nickName;
  @Enumerated
  @Column(name = "gender", nullable = false)
  private Gender gender;
  @Column(name = "prefecture_id", nullable = false)
  private Integer prefectureId;
  @Column(name = "email")
  private String email;
  @Column(name = "create_at", nullable = false)
  @JsonIgnore
  private LocalDateTime createAt;
  @Column(name = "update_at", nullable = false)
  @JsonIgnore
  private LocalDateTime updateAt;

  @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, // default
      cascade = CascadeType.ALL, orphanRemoval = true)
  @JsonManagedReference("customer")
  private List<CustomerOrder> customerOrders;

  @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, // default
      cascade = CascadeType.ALL, orphanRemoval = true)
  @JsonManagedReference("customer")
  private List<CustomerReview> customerReviews;

  @PrePersist
  private void prePersist() {
    createAt = LocalDateTime.now();
    updateAt = LocalDateTime.now();
  }

  @PreUpdate
  private void preUpdate() {
    updateAt = LocalDateTime.now();
  }

}
