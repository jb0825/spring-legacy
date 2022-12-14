package com.example.demo.mapper;

import com.example.demo.vo.TUser;
import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;

@Mapper
public interface TUserMapper {
    List<TUser> selectAllUsers();
    List<TUser> selectWithPaging(HashMap<String, Object> params);
    int selectUserCount();
    void insertUser(TUser user);
}
