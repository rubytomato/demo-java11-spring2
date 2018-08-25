package com.example.demo.entity;

import com.example.demo.type.OrderType;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Table(name = "customer_order")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CustomerOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "order_num", nullable = false)
    private Integer orderNum;
    @Column(name = "order_at", nullable = false)
    private LocalDateTime orderAt;
    @Enumerated
    @Column(name = "order_type", nullable = false)
    private OrderType orderType;
    @Column(name = "shipped_at")
    private LocalDateTime shippedAt;
    @Column(name = "cancel_flag", nullable = false)
    private Boolean cancelFlag;
    @ManyToOne(fetch = FetchType.EAGER) // default
    private Item item;
    @ManyToOne(fetch = FetchType.EAGER) // default
    @JsonBackReference("customer")
    //@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    //@JsonIdentityReference(alwaysAsId = true)
    private Customer customer;
    @Column(name = "create_at", nullable = false)
    @JsonIgnore
    private LocalDateTime createAt;
    @Column(name = "update_at", nullable = false)
    @JsonIgnore
    private LocalDateTime updateAt;

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
