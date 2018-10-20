package com.example.demo.controller;

import com.example.demo.entity.Memo;
import com.example.demo.service.MemoService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(path = "memo")
public class MemoController {

  private final MemoService memoService;
  private final static String SUCCESS = "success";

  public MemoController(MemoService service) {
    memoService = service;
  }

  @GetMapping(path = "{id}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<Memo> id(@PathVariable(value = "id") Long id) {
    Optional<Memo> memo = memoService.findById(id);
    return memo.map(ResponseEntity::ok)
        .orElseGet(() -> ResponseEntity.notFound()
            .build());
  }

  @GetMapping(path = "list", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<List<Memo>> list(Pageable page) {
    Page<Memo> memoPage = memoService.findAll(page);
    return ResponseEntity.ok(memoPage.getContent());
  }

  // Stream
  @GetMapping(path = "list2", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<List<Memo>> list2(@RequestParam("done") Boolean done) {
    List<Memo> memoPage = memoService.find(done);
    return ResponseEntity.ok(memoPage);
  }

  @GetMapping(path = "list3", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public ResponseEntity<List<Memo>> list3(@RequestParam("search") String search) {
    List<Memo> memoPage = memoService.findByDescriptionLike(search);
    return ResponseEntity.ok(memoPage);
  }

  @PostMapping(produces = MediaType.TEXT_PLAIN_VALUE, consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public String store(@RequestBody Memo memo) {
    memoService.store(memo);
    return "success";
  }

  @PutMapping(path = "{id}", produces = MediaType.TEXT_PLAIN_VALUE, consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
  public String update(@PathVariable(value = "id") Long id, @RequestBody Memo memo) {
    memoService.updateById(id, memo);
    return "success";
  }

  @DeleteMapping(path = "{id}", produces = MediaType.TEXT_PLAIN_VALUE)
  public String delete(@PathVariable(value = "id") Long id) {
    memoService.removeById(id);
    return "success";
  }

}
