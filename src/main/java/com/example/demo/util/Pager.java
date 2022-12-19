package com.example.demo.util;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Pager {
    private boolean prev = false;
    private boolean next = false;
    private int limit    = 10; // 한 페이지당 데이터수
    private int btnLimit = 10; // 페이지 버튼 개수
    private int pageCount;     // 전체 페이지
    private int pageNo;        // 현재 페이지
    private int dataCount;     // 전체 데이터 수
    private int startPage;
    private int endPage;

    /**
     * @param dataCount 총 데이터 개수
     * @param pageNo 페이지 번호
     */
    public Pager(int dataCount, int pageNo) {
        set(dataCount, pageNo);
    }

    /**
     * set limit
     * @param dataCount 총 데이터 개수
     * @param pageNo 페이지 번호
     * @param limit 페이지당 데이터 개수
     */
    public Pager(int dataCount, int pageNo, int limit) {
        this.limit = limit;
        set(dataCount, pageNo);
    }

    public void set(int dataCount, int pageNo) {
        this.pageNo = pageNo;
        this.dataCount = dataCount;
        this.pageCount = (int) Math.ceil((double) dataCount / limit);

        this.startPage = Math.max(1, pageNo - btnLimit / 2);
        this.endPage = Math.min(pageCount, startPage + btnLimit - 1);
        if (endPage == pageCount) this.startPage = Math.max(1, endPage - btnLimit + 1);

        if (pageNo > 1) this.prev = true;
        //if (pageNo < pageCount) this.next = true;
        if (pageNo < dataCount / limit) this.next = true;
    }

    public int getOffset() { return this.limit * (this.pageNo - 1); }
}
