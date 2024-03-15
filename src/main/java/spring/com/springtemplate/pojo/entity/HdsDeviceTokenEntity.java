package spring.com.springtemplate.pojo.entity;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import lombok.Data;
import lombok.Getter;
import lombok.experimental.Accessors;
import spring.com.springtemplate.enums.DeviceAccessType;
import spring.com.springtemplate.enums.DeviceTye;

import java.time.LocalDateTime;
/**
 * @Author qiang.long
 * @Date 2024/03/14
 * @Description
 **/
@Accessors(chain = true)
@Data
@TableName("hds_device_token")
public class HdsDeviceTokenEntity extends Model<HdsDeviceTokenEntity> {
    private static final long serialVersionUID=1L;
    private String deviceIp;
    @TableId("device_sn")
    private String deviceSn;
    private String token;
    private String userName;
    private String userPass;
    private LocalDateTime loginTime;
    private String serverToken;
    private Integer deviceAccessType;
    private Integer deviceType;
}
