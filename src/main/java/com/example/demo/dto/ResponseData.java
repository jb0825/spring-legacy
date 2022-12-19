package com.example.demo.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponseData {
    private boolean isSuccess;
    private String message;

    public ResponseData() {
        this.isSuccess = true;
        this.message = null;
    }
}