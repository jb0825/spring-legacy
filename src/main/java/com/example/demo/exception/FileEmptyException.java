package com.example.demo.exception;

public class FileEmptyException extends Exception {
    /**
     * 빈 파일 오류
     */
    public FileEmptyException() {
        super("파일의 내용이 없습니다");
    }
}
