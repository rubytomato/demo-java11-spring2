package com.example.demo.repository;

import com.example.demo.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.stream.Stream;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Stream<Customer> streamAllBy();
}
