package spring.com.springtemplate.enums;
import lombok.Getter;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/
@Getter
public enum ErrorCode {
    RESULT_SUCCESS(0,"请求成功"),
    BISINESS_FAIL(1,"业务处理失败");

    private  Integer code;
    private String msg;
    ErrorCode(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

}
