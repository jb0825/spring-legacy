package com.example.demo.service;

import com.example.demo.mapper.TUserMapper;
import com.example.demo.model.TUser;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
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

    public int[] insertAllUsers(MultipartFile file) throws IOException {
        AtomicInteger count = new AtomicInteger(1);

        InputStream inputStream = file.getInputStream();
        new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
                .lines().forEach(line -> {

            System.out.println(count + " : " + line);
            TUser user = new TUser(line.split("/"));
            count.addAndGet(1);
        });

        return null;
    }
}

