package com.example.demo.exception;

/**
 * 파일 확장자 오류
 */
public class FileExtException extends Exception {
    public FileExtException() {
        super("dbfile 만 업로드 할 수 있습니다.");
    }
}
