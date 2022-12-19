package com.example.demo.dto;

import com.example.demo.util.Pager;
import com.example.demo.vo.TUser;
import lombok.*;

import java.util.List;

@Getter
@Setter
@ToString
public class UserResponseData extends ResponseData {
    private List<TUser> users;
    private Pager pager;

    public UserResponseData() { super(); }

    public void setAll(List<TUser> users, Pager pager) {
        this.users = users;
        this.pager = pager;
    }
}
