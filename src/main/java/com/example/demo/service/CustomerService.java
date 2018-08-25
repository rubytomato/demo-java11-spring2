package com.example.demo.service;

import com.example.demo.entity.Customer;
import com.example.demo.entity.CustomerOrder;
import com.example.demo.entity.CustomerReview;
import com.example.demo.type.Gender;

import java.util.List;
import java.util.Optional;

public interface CustomerService {
  Optional<Customer> findById(Long id);

  List<Customer> findByGender(Gender gender);

  List<Customer> findByPrefectureId0(Integer prefectureId);

  List<Customer> findByPrefectureId(Integer prefectureId);

  List<CustomerOrder> findCustomerOrders(Long id);

  List<CustomerReview> findCustomerReviews(Long id);

  void changeNickName(Long id, String nickName);
}
