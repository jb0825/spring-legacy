package com.example.demo.service;

import com.example.demo.mapper.TUserMapper;
import com.example.demo.model.TUser;
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
public class TUserService {

    private final TUserMapper userMapper;

    public TUserService(TUserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public List<TUser> selectAllUsers() {
        return userMapper.selectAllUsers();
    }

    public Map<Integer, String> insertAllUsers(MultipartFile file) throws IOException {
        AtomicInteger count = new AtomicInteger(1);
        Map<Integer, String> failMap = new HashMap<>();
        InputStream inputStream = file.getInputStream();

        System.out.println("[insert]");

        new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)).lines().forEach(line -> {
            System.out.println(count + " : " + line);
            TUser user = new TUser(line.split("/"));

            try { userMapper.insertUser(user); }
            catch(Exception e) { failMap.put(count.intValue(), line); }

            count.addAndGet(1);
        });

        System.out.println("[insert fail]");
        for(Integer key : failMap.keySet()) System.out.println(key + " : " + failMap.get(key));
        return failMap;
    }

}

