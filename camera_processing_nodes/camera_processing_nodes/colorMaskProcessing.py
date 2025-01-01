import rclpy
from rclpy.node import Node
from rclpy.time import Time
from rclpy.executors import MultiThreadedExecutors
from sensor_msgs.msg import Image, CameraInfo
from cv_bridge import CvBridge, CvBridgeError
import cv2
import numpy as np
from collections import deque
from time_helpers import ImageMsgsIsCloseInTime
import yaml



class ConveyorbeltColorProcessing(Node):
  bridge = CvBridge()
  mask_config = yaml.load(open("../config/color_detection_classes.yaml","rb"), Loader=yaml.Loader)['classes']
  def __init__(self):
    self.rgb_camera_deque = deque()
    self.depth_camera_deque = deque()
    self.rgb_camera_info = None
    self.depth_camera_info = None
    self.rgb_image_subscriber = self.create_subscription(Image, "/rgb_camera", self.depth_camera_callback, 10)
    self.depth_image_subscriber = self.create_subscription(Image, "/depth_camera", self.depth_camera_callback, 10)
    self.rgb_info_subscription = self.create_subscription(CameraInfo, "/depth_info", self.rgb_info_callback, 10)
    self.depth_info_subscription = self.create_subscription(CameraInfo, "/rgb_info", self.depth_info_callback, 10)

    #TODO: this is for debug
    self.blue_mask_publisher = self.create_publisher(Image, "/blue_mask", 10)
    self.red_mask_publisher = self.create_publisher(Image, "/red_mask", 10)


  def rgb_camera_callback(self, msg:Image):
    self.rgb_camera_deque.append(msg)
    if len(self.rgb_camera_deque) > 5:
      self.rgb_camera_deque.popleft()
    if ImageMsgsIsCloseInTime(self.rgb_camera_deque[0],self.depth_camera_deque[1])
      self.process_images(self.rgb_camera_deque[0],self.depth_camera_deque[1])

  def depth_camera_callback(self, msg:Image):
    self.depth_camera_deque.append(msg)
    if len(self.depth_camera_deque) > 5:
      self.depth_camera_deque.popleft()
    if ImageMsgsIsCloseInTime(self.rgb_camera_deque[0],self.depth_camera_deque[1])
      self.process_images(self.rgb_camera_deque[0], self.depth_camera_deque[1])
      
    #TODO: implement info callacks
  def rgb_info_callback(self, msg:CameraInfo):
    pass

  def depth_info_callback(self, msg:CameraInfo):
    pass
    

  def process_images(rgb_msg:Image, depth_msg:Image):
    hsv_color_img = None
    depth_img = None
    try:
      depth_img = self.bridge.imgmsg_to_cv2(depth_msg, desired_encoding="passthrough")
      hsv_color_img = cv2.cvtColor(self.bridge.imgmsg_to_cv2(rgb_msg,desired_encoding="passthrough"), cv2.COLOR_BGR2HSV)
    except CvBridgeError as e:
        self.get_logger().info(f"{e} error images not being processed")
    mask_dictionary = {}
    for color in self.mask_config:
      color_key = color.keys()[0]
      color_upper_bound = np.array([color[color_key]['channels']['hue']['upper_bound'],
                                    color[color_key]['channels']['saturation']['upper_bound'],
                                    color[color_key]['channels']['value']['upper_bound'],])
      color_lower_bound = np.array([color[color_key]['channels']['hue']['lower_bound'],
                                    color[color_key]['channels']['saturation']['lower_bound'],
                                    color[color_key]['channels']['value']['lower_bound'],])

      mask_dictionary[color_key] = cv2.inRange(hsv_color_img,color_upper_bound,color_lower_bound)
    print(np.unique(mask_dictionary["red"],return_counts=True))
    print(np.unique(mask_dictionary["blue"],return_counts=True))



def main(args=None):
  rclpy.init(args=None)
  node = CoveyorBeltColorProccesing(Node):
  rclpy.spin(node)
  node.destroy_node()
  rclpy.shutdown()


if __name__ == "__main__":
  main()
