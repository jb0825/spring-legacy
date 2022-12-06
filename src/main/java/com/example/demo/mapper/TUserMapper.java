package com.example.demo.mapper;

import com.example.demo.model.TUser;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TUserMapper {
    List<TUser> selectAllUsers();
}
