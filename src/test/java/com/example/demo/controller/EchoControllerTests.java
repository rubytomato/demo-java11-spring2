package com.example.demo.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(value = EchoController.class, properties = "spring.active.profiles=test")
public class EchoControllerTests {

  @Autowired
  private MockMvc mvc;

  @Test
  public void page() throws Exception {

    MvcResult result = this.mvc.perform(get("/page")
        .param("page", "0")
        .param("size", "20")
        .param("sort", "id,desc"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.pageNumber", is(0)))
        .andExpect(jsonPath("$.pageSize", is(20)))
        .andExpect(jsonPath("$.offset", is(0)))
        .andExpect(jsonPath("$.paged", is(true)))
        .andExpect(jsonPath("$.unpaged", is(false)))
        .andExpect(jsonPath("$.sort.sorted", is(true)))
        .andExpect(jsonPath("$.sort.unsorted", is(false)))
        .andDo(print())
        .andReturn();

    System.out.println("***");
    System.out.println(result.getResponse().getContentAsString());
    System.out.println("***");
  }

}
