package com.example.demo.exception;

/**
 * 빈 파일 오류
 */
public class FileEmptyException extends Exception {
    public FileEmptyException() {
        super("파일의 내용이 없습니다");
    }
}
