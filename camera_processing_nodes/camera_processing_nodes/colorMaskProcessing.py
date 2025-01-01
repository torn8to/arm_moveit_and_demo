import rclpy
from rclpy.node import Node
from rclpy.time import Time
from rclpy.executors import MultiThreadedExecutor
from rclpy.callback_groups import ReentrantCallbackGroup
from sensor_msgs.msg import Image, CameraInfo
from graspable_shape_msgs.msg import ColorMask
from cv_bridge import CvBridge, CvBridgeError
import cv2
import numpy as np
from collections import deque
from time_helpers import ImageMsgsIsCloseInTime
import yaml
import threading



class ConveyorbeltColorProcessing(Node):
  bridge = CvBridge()
  mask_config = yaml.load(open("../config/color_detection_classes.yaml","rb"), Loader=yaml.Loader)['classes']
  cbg = ReentrantCallbackGroup()
  def __init__(self):
    super().__init__('conveyor_color_detection')
    self.rgb_camera_deque = deque()
    self.depth_camera_deque = deque()
    self.rgb_camera_info = None
    self.depth_camera_info = None
    self.rgb_image_subscriber = self.create_subscription(Image, "/rgb_camera", self.rgb_camera_callback, 10, callback_group=self.cbg)
    self.depth_image_subscriber = self.create_subscription(Image, "/depth_camera", self.depth_camera_callback, 10, callback_group=self.cbg)
    self.rgb_info_subscription = self.create_subscription(CameraInfo, "/depth_info", self.rgb_info_callback, 10, callback_group=self.cbg)
    self.depth_info_subscription = self.create_subscription(CameraInfo, "/rgb_info", self.depth_info_callback, 10, callback_group=self.cbg)

    #TODO: this is for debug
    self.class_mask_publisher = self.create_publisher(ColorMask,'detected_class_images',10)


  def rgb_camera_callback(self, msg:Image):
    self.rgb_camera_deque.appendleft(msg)
    if len(self.rgb_camera_deque) > 5:
      print(f"rgb{msg.header.stamp}")
      self.rgb_camera_deque.pop()
    if len(self.depth_camera_deque) > 0 and ImageMsgsIsCloseInTime(self.rgb_camera_deque[0],self.depth_camera_deque[0]):
      print(f"rgb{msg.header.stamp}")
      self.process_images(self.rgb_camera_deque[0],self.depth_camera_deque[0])

  def depth_camera_callback(self, msg:Image):
    self.depth_camera_deque.appendleft(msg)
    if len(self.depth_camera_deque) > 5:
      self.depth_camera_deque.pop()
    if  len(self.rgb_camera_deque) > 0 and ImageMsgsIsCloseInTime(self.rgb_camera_deque[0],self.depth_camera_deque[0]):
      print(f" depth {msg.header.stamp}")
      self.process_images(self.rgb_camera_deque[0], self.depth_camera_deque[0])
      
    #TODO: implement info callacks
  def rgb_info_callback(self, msg:CameraInfo):
    pass

  def depth_info_callback(self, msg:CameraInfo):
    pass
    

  def process_images(self, rgb_msg:Image, depth_msg:Image):
    print(f"reach process images")
    hsv_color_img = None
    depth_img = None
    try:
      depth_img = self.bridge.imgmsg_to_cv2(depth_msg, desired_encoding="passthrough")
      hsv_color_img = cv2.cvtColor(self.bridge.imgmsg_to_cv2(rgb_msg, desired_encoding="passthrough"), cv2.COLOR_RGB2HSV)
    except CvBridgeError as e:
        self.get_logger().info(f"{e} error images not being processed")

    mask_dictionary = {}
    for color in self.mask_config:
      color_key = list(color.keys())[0]
      color_upper_bound = np.array([color[color_key]['channels']['hue']['upper_bound'],
                                    color[color_key]['channels']['saturation']['upper_bound'],
                                    color[color_key]['channels']['value']['upper_bound'],])

      color_lower_bound = np.array([color[color_key]['channels']['hue']['lower_bound'],
                                    color[color_key]['channels']['saturation']['lower_bound'],
                                    color[color_key]['channels']['value']['lower_bound'],])

      mask_dictionary[color_key] = cv2.inRange(hsv_color_img, color_lower_bound, color_upper_bound)
    mc_msg = ColorMask()
    red_depth =  np.where(mask_dictionary["red"] > 120, depth_img, 0)
    blue_depth =  np.where(mask_dictionary["blue"]  > 120, depth_img, 0)
    cm_msg.red_mask = self.bridge.cv2_to_imgmsg(red_depth)
    cm_msdg.blue_mask = self.bridge.cv2_to_imgmsg(blue_depth)
    self.mask_publisher.publish(cm_msg)


def main(args=None):
  rclpy.init(args=args)
  cd_node =ConveyorbeltColorProcessing()
  executor = MultiThreadedExecutor(num_threads=2)
  executor.add_node(cd_node)
  executor.spin()
  node.destroy_node()
  rclpy.shutdown()


if __name__ == "__main__":
  main()
