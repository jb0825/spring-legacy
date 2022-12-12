package com.example.demo.service;

import com.example.demo.dto.FailData;
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
import java.util.stream.Stream;

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

    public FailData insertAllUsers(MultipartFile file) throws Exception {
        String fileName = file.getOriginalFilename();
        if (fileName == null || !fileName.split("\\.")[1].equals("dbfile"))
            throw new FileExtException();

        Map<Integer, String> failMap = new HashMap<>();
        int success = 0;
        int fail = 0;
        int idx = 0;

        try (
            InputStream is = file.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
        ){
            String line = null;
            while ((line = br.readLine()) != null) {
                try {
                    userMapper.insertUser(new TUser(line.split("/")));
                    success++;
                } catch (Exception e) {
                    failMap.put(idx, line);
                    fail++;
                } finally { idx++; }
            }
            
        } catch(IOException e) { throw new Exception(); }

        if (success == 0 && fail == 0) throw new FileEmptyException();
        if (success == idx) failMap = null;

        return new FailData(failMap, success, fail);
    }
}

