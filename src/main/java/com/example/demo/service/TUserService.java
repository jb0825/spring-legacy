package com.example.demo.service;

import com.example.demo.mapper.TUserMapper;
import com.example.demo.model.TUser;
import lombok.Data;
import lombok.Getter;
import org.postgresql.util.PSQLException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@Service
@Data
public class TUserService {

    private final TUserMapper userMapper;
    public int success;
    public int fail;

    public TUserService(TUserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public List<TUser> selectAllUsers() {
        return userMapper.selectAllUsers();
    }

    public Map<Integer, String> insertAllUsers(MultipartFile file) throws Exception {
        String fileName = file.getOriginalFilename();
        if (fileName == null && !fileName.split("\\.")[1].equals("dbfile"))
            throw new Exception();

        Map<Integer, String> failMap = new HashMap<>();
        AtomicInteger count = new AtomicInteger();
        InputStream inputStream = file.getInputStream();
        this.success = 0; this.fail = 0;

        System.out.println("----------");
        new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)).lines().forEach(line -> {
            TUser user = new TUser(line.split("/"));

            try {
                userMapper.insertUser(user);
                System.out.println("success: " + user);
                success++;
            }
            catch(Exception e) {
                failMap.put(count.getAndIncrement(), line);
                System.out.println("fail: " + user);
                fail++;
            }
        });

        return success == count.intValue() ? null : failMap;
    }
}

