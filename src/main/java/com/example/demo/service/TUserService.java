package com.example.demo.service;

import com.example.demo.dto.FailInfo;
import com.example.demo.exception.FileEmptyException;
import com.example.demo.exception.FileExtException;
import com.example.demo.mapper.TUserMapper;
import com.example.demo.vo.TUser;
import lombok.Data;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

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

    public FailInfo insertAllUsers(MultipartFile file) throws Exception {
        String fileName = file.getOriginalFilename();
        if (fileName == null || !fileName.split("\\.")[1].equals("dbfile"))
            throw new FileExtException();

        FailInfo result = new FailInfo();
        try (
            InputStream is = file.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
        ){
            String line = null;
            int idx = 1;

            while ((line = br.readLine()) != null) {
                try {
                    userMapper.insertUser(new TUser(line.split("/")));
                    result.increaseSuccess();
                } catch (Exception e) {
                    result.addFailLine(idx, line);
                    result.increaseFail();
                } finally { idx++; }
            }
        } catch(IOException e) { throw new Exception(); }

        if (result.getTotalCount() == 0) throw new FileEmptyException();
        return result;
    }
}

