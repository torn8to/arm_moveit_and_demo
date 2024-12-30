#!/usr/bin/env python3

from rclpy.node import Node
import rclpy

from sensor_msgs.msg import LaserScan
from std_msg.msg import float64


class ConveyorControllerLaserSafetyNode(Node):
  def __init__(self):
    super().__init__('conveyor_laser_safety_controller_node')
    self.declare_parameter('laserscan_threshold', 0.15)
    self.laser_obstruction_threshold = self.get_parameter('laserscan_threshold').value
    self.laser_subscriber = self.create_subscription(LaserScan,'/conveyor_laser',self.conveyor_callback,10)
    self.conveyor_velocity_controller = create_publisher("/model/conveyor/link/base_link_track_cmd_vel",)


  def laser_callback(self,msg:LaserScan):
    if msg.range < self.threshold:
      self.conveyor_velocity_controller.publish(Float64(data=0.0)))

def main(args=None):
  rclpy.init(args=args)
  node = ConveyorControllerLaserSafety()]
  rclpy.spin(node)
  node.destroy_node()
  rclpy.shutdown()





if __name__ == "__main__":
    main()
