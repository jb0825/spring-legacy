package com.example.demo.model;

import lombok.*;

import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class TUser {

    private String id;
    private String pwd;
    private String name;
    private char level;
    private String description;
    private Timestamp regDate;

    public TUser(String[] arr) {
        this.id = arr[0];
        this.pwd = arr[1];
        this.name = arr[2];
        this.level = arr[3].charAt(0);
        this.description = arr[4];
        this.regDate = Timestamp.valueOf(arr[5]);
    }
}
