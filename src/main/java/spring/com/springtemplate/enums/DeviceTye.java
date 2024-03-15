package spring.com.springtemplate.enums;
import lombok.Getter;
/**
 * @Author qiang.long
 * @Date 2024/03/15
 * @Description
 **/
@Getter
public enum DeviceTye {
    SE5(0,"SE5"),
    SE6(1,"SE6"),
    SE7(2,"SE7"),
    SE8(3,"SE8");

    private final Integer code;
    private final String model;
    DeviceTye(Integer code, String model) {
        this.code = code;
        this.model = model;
    }
}
