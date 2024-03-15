package spring.com.springtemplate.service;
import spring.com.springtemplate.vo.Result;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/
public interface SampleService {
    Result<String> getToken(String deviceSn);
}
