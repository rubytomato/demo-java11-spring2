package com.example.demo.service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@SpringBootTest
public class ExampleServiceTests {

  @SpyBean(classes = {ExampleService.class})
  ExampleService service;

  @Test
  public void test() {
    System.out.println(service.getName());
  }

  interface ExampleService {
    String getName();
  }

  static class ExampleServiceImpl implements ExampleService {
    private String name;

    public ExampleServiceImpl(String name) {
      this.name = name;
    }

    @Override
    public String getName() {
      return this.name;
    }
  }

  @Configuration
  static class ExampleConfigure {

    @Bean
    public ExampleService example1() {
      return new ExampleServiceImpl("example1");
    }

    @Bean
    @Primary
    public ExampleService example2() {
      return new ExampleServiceImpl("example2");
    }

  }

}
