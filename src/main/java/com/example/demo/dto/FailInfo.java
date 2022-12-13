package com.example.demo.dto;

import com.google.gson.Gson;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class FailInfo {
    private List<FailData> list;
    private String data;
    private int success;
    private int fail;

    public FailInfo() {
        this.list = new ArrayList<>();
        this.success = 0;
        this.fail = 0;
    }

    public void increaseSuccess() { this.success++; }
    public void increaseFail() { this.fail++; }
    public int getTotalCount() { return this.success + this.fail; }

    public void listToJSON() { this.data = new Gson().toJson(list); }

    public void addFailLine(int lineNumber, String lineText){
        this.list.add(new FailData(lineNumber, lineText));
    }
}
