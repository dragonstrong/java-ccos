package spring.com.springtemplate.controller;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import com.alibaba.fastjson.JSON;
import spring.com.springtemplate.enums.DeviceAccessType;
import spring.com.springtemplate.enums.DeviceTye;
import spring.com.springtemplate.mapper.HdsDeviceTokenMapper;
import spring.com.springtemplate.pojo.dto.DeviceTokenDTO;
import spring.com.springtemplate.pojo.entity.HdsDeviceTokenEntity;
import spring.com.springtemplate.service.impl.SampleServiceImpl;
import spring.com.springtemplate.vo.Result;

import java.time.LocalDateTime;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/
@Slf4j
@RestController
@RequestMapping("/ql")
public class SampleController {
    @Resource
    private SampleServiceImpl sampleServiceImpl;
    @Resource
    private HdsDeviceTokenMapper hdsDeviceTokenMapper;
    @GetMapping("/test")
    public Result<?> getName(){
        return Result.ok("this is my first api");
    }
    @PostMapping("/token")
    public Result<String> getToken(@RequestBody DeviceTokenDTO deviceTokenDTO){
        log.info("get device Token, {}", JSON.toJSONString(deviceTokenDTO));
        return sampleServiceImpl.getToken(deviceTokenDTO.getDeviceSn());
    }

    @PostMapping("/insert/device")
    public Result<Boolean> insertDeviceToken(@RequestBody HdsDeviceTokenEntity hdsDeviceTokenEntity){
        log.info("insert hdsDeviceTokenEntity:{}",JSON.toJSONString(hdsDeviceTokenEntity));
        hdsDeviceTokenEntity.setLoginTime(LocalDateTime.now());
        return Result.ok(hdsDeviceTokenMapper.insert(hdsDeviceTokenEntity)>0);
    }
}
