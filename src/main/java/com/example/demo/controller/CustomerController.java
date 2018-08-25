package com.example.demo.controller;

import com.example.demo.entity.Customer;
import com.example.demo.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping(path = "customer")
@Slf4j
public class CustomerController {

  private final CustomerService service;

  public CustomerController(CustomerService service) {
    this.service = service;
  }

  @GetMapping(path = "{id}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<Customer> id(@PathVariable(value = "id") Long id) {
    Optional<Customer> customer = service.findById(id);
    return customer.map(ResponseEntity::ok)
        .orElseGet(() -> ResponseEntity.notFound().build());
  }

  @GetMapping(path = "prefecture/{id}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<Integer> list(@PathVariable(value = "id") Integer id) {
    List<Customer> customers = service.findByPrefectureId0(id);
    //List<Customer> customers = service.findByPrefectureId(id);
    return ResponseEntity.ok(customers.size());
  }

  @PutMapping(path = "{id}", produces = MediaType.TEXT_PLAIN_VALUE, consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public String changeNickName(@PathVariable(value = "id") Long id, @RequestBody Map<String, String> payload) {
    log.info("id:{}, newNickName:{}", id, payload.get("nickName"));
    service.changeNickName(id, payload.get("nickName"));
    return "success";
  }

}
