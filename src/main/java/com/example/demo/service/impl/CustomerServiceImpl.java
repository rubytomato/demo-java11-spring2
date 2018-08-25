package com.example.demo.service.impl;

import com.example.demo.entity.Customer;
import com.example.demo.entity.CustomerOrder;
import com.example.demo.entity.CustomerReview;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.service.CustomerService;
import com.example.demo.type.Gender;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.jpa.QueryHints;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@Slf4j
public class CustomerServiceImpl implements CustomerService {

  private final CustomerRepository customerRepository;
  private final EntityManager entityManager;

  public CustomerServiceImpl(CustomerRepository customerRepository, EntityManager entityManager) {
    this.customerRepository = customerRepository;
    this.entityManager = entityManager;
  }

  @Transactional(readOnly = true, timeout = 3)
  @Override
  public Optional<Customer> findById(Long id) {
    return customerRepository.findById(id);
  }

  @Transactional(readOnly = true, timeout = 10)
  @Override
  public List<Customer> findByGender(final Gender gender) {
    try (Stream<Customer> customers = customerRepository.streamAllBy()) {
      return customers
          .filter(customer -> customer.getGender() == gender)
          .limit(100)
          .collect(Collectors.toList());
    }
  }

  @Transactional(readOnly = true, timeout = 30)
  @Override
  public List<Customer> findByPrefectureId0(Integer prefectureId) {
    String sql = "SELECT c FROM Customer c WHERE c.prefectureId = :prefectureId ORDER BY c.id ASC";
    TypedQuery<Customer> query = entityManager.createQuery(sql, Customer.class);
    log.debug("start");
    try {
      List<Customer> customers = query
          .setParameter("prefectureId", prefectureId)
          .setHint(QueryHints.HINT_FETCH_SIZE, 100)
          .setFirstResult(0)
          .setMaxResults(30000)
          .getResultList();
      log.debug("mid");
      return customers.stream()
          .peek(customer -> {
            log.debug("   Id:{}", customer.getId());
          })
          .collect(Collectors.toList());
    } finally {
      log.debug("end");
    }
  }

  @Transactional(readOnly = true, timeout = 30)
  @Override
  public List<Customer> findByPrefectureId(Integer prefectureId) {
    String sql = "SELECT c FROM Customer c WHERE c.prefectureId = :prefectureId ORDER BY c.id ASC";
    TypedQuery<Customer> query = entityManager.createQuery(sql, Customer.class);
    System.out.println(query.getClass().getCanonicalName());
    // try (Stream<Customer> customers = entityManager.createQuery(sql, Customer.class)
    log.debug("start");
    try (Stream<Customer> customers = query
        .setParameter("prefectureId", prefectureId)
        .setHint(QueryHints.HINT_FETCH_SIZE, 100)
        .setFirstResult(0)
        .setMaxResults(30000)
        .getResultStream()) {
      log.debug("mid");
      return customers
          .peek(customer -> {
            log.debug("   Id:{}", customer.getId());
          })
          .collect(Collectors.toList());
    } finally {
      log.debug("end");
    }
  }

  @Transactional(readOnly = true, timeout = 10)
  @Override
  public List<CustomerOrder> findCustomerOrders(Long id) {
    Customer customer = customerRepository.findById(id).orElseThrow(() -> new RuntimeException("not exists customer"));
    return customer.getCustomerOrders();
  }

  @Transactional(readOnly = true, timeout = 10)
  @Override
  public List<CustomerReview> findCustomerReviews(Long id) {
    return customerRepository.findById(id).map(Customer::getCustomerReviews).orElseThrow(() -> new RuntimeException("not exists customer"));
  }

  @Transactional(timeout = 3)
  @Override
  public void changeNickName(Long id, String nickName) {
    customerRepository.findById(id).ifPresent(customer -> customer.setNickName(nickName));
  }

}
