from sensor_msgs.msg import Image
from rclpy.time import Time


def ImageMsgsIsCloseInTime(msg1: Image, msg2: Image, threshole:int = 10000) -> bool:
  time1:Time = Time.from_msg(msg1.header.stamp)
  time2:Time = Time.from_msg(msg2.header.stamp)
  return  abs(time_to_number(time1) - time_to_number(time2)) < threshold

def time_to_number(t:Time) -> int:
  t_tuple = t.seconds_nanoseconds()
  return t_tuple[0] * 1_000_000_000 + t_tuple[1]
