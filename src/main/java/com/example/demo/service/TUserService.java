package com.example.demo.service;

import com.example.demo.dto.FailInfo;
import com.example.demo.exception.FileEmptyException;
import com.example.demo.exception.FileExtException;
import com.example.demo.mapper.TUserMapper;
import com.example.demo.util.Pager;
import com.example.demo.vo.TUser;
import lombok.Data;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Data
public class TUserService {

    private final TUserMapper userMapper;

    public TUserService(TUserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public List<TUser> selectAllUsers() { return userMapper.selectAllUsers(); }

    /**
     * get paged List<T_User> from DB
     * @param pager (offset, limit)
     * @return paged user list
     */
    public List<TUser> selectWithPaging(Pager pager) {
        HashMap<String, Object> params = new HashMap<>();
        params.put("offset", pager.getOffset());
        params.put("limit", pager.getLimit());

        return userMapper.selectWithPaging(params);
    }

    /**
     * get pager & paged user list
     * @param pageNo current page
     * @return Map { users: List, pager: Pager }
     * @see Pager
     * @see TUserService#selectWithPaging(Pager)
     */
    public Map<String, Object> getPagedUser(int pageNo) {
        int dataCount = userMapper.selectUserCount();
        Pager pager = new Pager(dataCount, pageNo);
        List<TUser> users = selectWithPaging(pager);
        Map<String, Object> data = new HashMap<>();

        data.put("users", users);
        data.put("pager", pager);
        return data;
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

