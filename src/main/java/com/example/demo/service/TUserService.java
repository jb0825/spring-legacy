package com.example.demo.service;

import com.example.demo.exception.FileEmptyException;
import com.example.demo.exception.FileExtException;
import com.example.demo.mapper.TUserMapper;
import com.example.demo.vo.TUser;
import lombok.Data;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.StandardCharsets;
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
        if (fileName == null || !fileName.split("\\.")[1].equals("dbfile"))
            throw new FileExtException();

        Map<Integer, String> failMap = new HashMap<>();
        AtomicInteger count = new AtomicInteger(1);
        InputStream inputStream = file.getInputStream();

        this.success = 0; this.fail = 0;

        new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)).lines().forEach(line -> {
            try {
                TUser user = new TUser(line.split("/"));
                userMapper.insertUser(user);
                success++;
            }
            catch(Exception e) {
                failMap.put(count.get(), line);
                fail++;
            }
            finally { count.incrementAndGet(); }
        });

        if (success == 0 && fail == 0) throw new FileEmptyException();
        return success == count.intValue() ? null : failMap;
    }
}

