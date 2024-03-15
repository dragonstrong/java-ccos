package spring.com.springtemplate.vo;
import com.fasterxml.jackson.annotation.JsonProperty;
import spring.com.springtemplate.enums.ErrorCode;
import java.io.Serializable;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/
public class Result<T> implements Serializable {
    private static final long serialVersionUID=899999999999999999L;
    @JsonProperty("Code")
    private Integer code;
    @JsonProperty("Msg")
    private String msg;
    @JsonProperty("Result")
    private T result;
    public Result(Integer code, String msg, T result) {
        this.code = code;
        this.msg = msg;
        this.result = result;
    }
    public Result() {
    }


    public static Result ok(){
        return (new Result()).code(ErrorCode.RESULT_SUCCESS.getCode()).msg(ErrorCode.RESULT_SUCCESS.getMsg());
    }
    public static <T> Result<T> ok(T result){
        return (new Result()).code(ErrorCode.RESULT_SUCCESS.getCode()).msg(ErrorCode.RESULT_SUCCESS.getMsg()).result(result);
    }

    public static <T> Result<T> errorResult(T result){
        return (new Result()).code(ErrorCode.BISINESS_FAIL.getCode()).msg(ErrorCode.BISINESS_FAIL.getMsg()).result(result);
    }



    public Integer getCode() {
        return code;
    }
    public String getMsg() {
        return msg;
    }
    public T getResult() {
        return result;
    }
    public Result<T> code(Integer code) {
        this.code = code;
        return this;
    }
    public Result<T> msg(String msg) {
        this.msg = msg;
        return this;
    }
    public Result<T> result(T result) {
        this.result = result;
        return this;
    }
}
