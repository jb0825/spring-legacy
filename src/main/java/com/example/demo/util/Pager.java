package com.example.demo.util;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Pager {
    private boolean prev = false;
    private boolean next = false;
    private int limit = 10;   // 한 페이지당 데이터수
    private int btnLimit = 5; // 페이지 버튼 개수
    private int pageCount;    // 전체 페이지
    private int pageNo;       // 현재 페이지
    private int dataCount;    // 전체 데이터 수
    private int startPage;
    private int endPage;

    /**
     * current page info
     * @param dataCount 총 데이터 개수
     * @param pageNo 페이지 번호
     */
    public Pager(int dataCount, int pageNo) {
        this.pageNo = pageNo;
        this.pageCount = dataCount / limit;

        this.startPage = (pageNo < btnLimit) ? 1 : pageNo - btnLimit / 2;
        this.endPage = startPage + btnLimit - 1;
        if (endPage >= pageCount) {
            this.startPage = pageCount - btnLimit + 1;
            this.endPage = pageCount;
        }

        if (pageNo > 1) this.prev = true;
        if (pageNo < pageCount) this.next = true;
    }

    public int getOffset() { return this.limit * (this.pageNo - 1); }
}
