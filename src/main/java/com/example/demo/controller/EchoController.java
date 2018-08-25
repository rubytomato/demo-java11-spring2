package com.example.demo.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EchoController {

  @GetMapping(path = "echo/{message}")
  public String echo(@PathVariable(value = "message") String message) {
    return message;
  }

  @GetMapping(path = "echo2/{message}")
  public String echo2(@PathVariable(value = "message") String message, @RequestParam("param1") String param1, @RequestParam("param2") String param2) {
    return String.format("message:[%s], param1:[%s], param2:[%s]", message, param1, param2);
  }

  @PostMapping(path = "echo3")
  public String echo3(@RequestParam("message") String message, @RequestParam("param1") String param1, @RequestParam("param2") String param2) {
    return String.format("message:[%s], param1:[%s], param2:[%s]", message, param1, param2);
  }

  @GetMapping(path = "page")
  public ResponseEntity<Pageable> page(Pageable page) {
    return ResponseEntity.ok(page);
  }

}
