package com.example.demo.controller;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = "spring.active.profiles=test")
public class EchoControllerIntegrationTests {

  @Autowired
  private TestRestTemplate restTemplate;

  @Test
  public void echo() {
    String actual = this.restTemplate.getForObject("/echo/hello world", String.class);
    assertThat(actual).isEqualTo("hello world");
  }

  @Test
  public void page() {
    String actual = this.restTemplate.getForObject("/page?page={page}&size={size}&sort={sort}", String.class, 0, 20, "id,desc");
    System.out.println(actual);
    DocumentContext document = JsonPath.parse(actual);
    assertThat(document.read("$.pageNumber", Number.class)).isEqualTo(0);
    assertThat(document.read("$.pageSize", Number.class)).isEqualTo(20);
    assertThat(document.read("$.offset", Number.class)).isEqualTo(0);
  }

}
