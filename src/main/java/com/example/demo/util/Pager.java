package com.example.demo.util;

import com.example.demo.vo.TUser;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class Pager {
    private int limit;      // 한 페이지당 데이터수
    private int btnLimit;   // 페이지 버튼 개수
    private int dataCount;  // 총 데이터수
    private int pageCount;  // 전체 페이지
    private int pageNo;     // 현재 페이지
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;

    public Pager(int dataCount, int pageNo) {
        this.limit = 10;
        this.btnLimit = 3;
        this.dataCount = dataCount;
        this.pageNo = pageNo;
        this.prev = false;
        this.next = false;

        this.pageCount = (int) Math.ceil((float) dataCount / limit);
        this.startPage = pageNo == 1 ? 1 : pageNo - 1;
        this.endPage = startPage + btnLimit - 1;

        if (endPage >= pageCount) this.endPage = pageCount;
        if (pageNo > 1) this.prev = true;
        if (pageNo < pageCount) this.next = true;
    }

    public int getOffset() { return this.limit * (this.pageNo - 1); }
}
