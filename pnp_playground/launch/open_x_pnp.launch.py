import os
from ament_index_python.packages import get_package_share_path
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, ExecuteProcess
from launch.substitutions import Command, LaunchConfiguration
from launch_ros import parameter_descriptions as pd
from launch_ros.actions import Node

def generate_launch_description():
    package_path = 'open_manipulator_x_description'
    model_path = "open_manipulator_demo_with_camera.urdf.xacro"
    sdf_file_default = "open_x_pick_and_place_task.sdf"
    playground_package_path = get_package_share_path('pnp_playground')

    use_sim_time = LaunchConfiguration('use_sim_time')

    use_sim_time_arg = DeclareLaunchArgument(
        name='use_sim_time', default_value="true", description='whether to use simulator time or real time ')

    arm_desc_path = get_package_share_path(package_path)
    default_model_path = os.path.join(arm_desc_path, 'urdf', model_path)
    robot_description = pd.ParameterValue(
        Command(['xacro ', default_model_path]), value_type=str)

    robot_controllers = os.path.join(get_package_share_path(
        'open_manipulator_x_description'), 'config', 'arm_controler.yaml')

    gz_sim_command = ExecuteProcess(cmd=['ros2',
                                         'launch',
                                         'ros_gz_sim',
                                         'gz_sim.launch.py',
                                         f'gz_args:={os.path.join(playground_package_path, 'gazebo', sdf_file_default)} -v  -r'], output="screen")

    ros_gz_parameter_bridge = Node(package="ros_gz_bridge",
                                   executable='parameter_bridge',
                                   arguments=[
                                       "/clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock",
                                       "/tf@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V",
                                       '/joint_states@sensor_msgs/msg/JointState[gz.msgs.Model',
                                       '/camera_info@sensor_msgs/msg/CameraInfo@gz.msgs.CameraInfo',
                                       '/rgb_camera_info@sensor_msgs/msg/CameraInfo@gz.msgs.CameraInfo',
                                       '/rgb_camera@sensor_msgs/msg/Image@gz.msgs.Image',
                                        '/depth_camera_info@sensor_msgs/msg/CameraInfo@gz.msgs.CameraInfo',
                                       '/depth_camera@sensor_msgs/msg/Image@gz.msgs.Image',
                                       '/depth_camera/points@sensor_msgs/msg/PointCloud2@gz.msgs.PointCloudPacked',
                                       '/model/conveyor/link/base_link/track_cmd_vel@std_msgs/msg/Float64@gz.msgs.Double',
                                       '/conveyor_laser@sensor_msgs/msg/LaserScan@gz.msgs.LaserScan'
                                   ])

    robot_state_publisher = Node(package="robot_state_publisher",
                                 executable="robot_state_publisher",
                                 name='arm_state_publisher',
                                 parameters=[{'use_sim_time': use_sim_time, 'robot_description': robot_description}])

    joint_state_publisher = Node(package="joint_state_publisher",
                                 executable="joint_state_publisher",
                                 name='joint_state_publisher',
                                 parameters=[{'use_sim_time': use_sim_time}],)
    gz_spawn_entity = Node(
        package="ros_gz_sim",
        executable="create",
        arguments=[
            "-topic", "/robot_description",
            "-name", "arm_camera",
            "-allow_renaming", "true",
            "-z", "1.2",
            "-x", "-0.2",
        ]
    )

    controller_manager = Node(package="controller_manager",
                              executable="ros2_control_node",
                              parameters=[robot_controllers],
                              output="both")

    return LaunchDescription([gz_sim_command,
                              ros_gz_parameter_bridge,
                              #controller_manager,
                              gz_spawn_entity,
                              use_sim_time_arg,
                              robot_state_publisher,
                              joint_state_publisher])
