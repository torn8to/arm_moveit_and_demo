<?xml version="1.0" ?>

<sdf version="1.6">
  <world name="recycling">
    <physics name="1ms" type="ignored">
      <max_step_size>0.004</max_step_size>
      <real_time_factor>1.0</real_time_factor>
      <real_time_update_rate>100</real_time_update_rate>
    </physics>
    <plugin
      filename="gz-sim-physics-system"
      name="gz::sim::systems::Physics">
    </plugin>
    <plugin
      filename="gz-sim-user-commands-system"
      name="gz::sim::systems::UserCommands">
    </plugin>
    <plugin
      filename="gz-sim-scene-broadcaster-system"
      name="gz::sim::systems::SceneBroadcaster">
    </plugin>
    <plugin
      filename="gz-sim-contact-system"
      name="gz::sim::systems::Contact">
    </plugin>
    <plugin
      filename="gz-sim-sensors-system"
      name="gz::sim::systems::Sensors">
      <render_engine>ogre2</render_engine>
      </plugin>
    <gui>
      <plugin filename="MinimalScene" name="3D View">
        <gz-gui>
          <title>3D View</title>
          <property type="bool" key="showTitleBar">false</property>
          <property type="string" key="state">docked</property>
        </gz-gui>

        <engine>ogre2</engine>
        <scene>scene</scene>
        <ambient_light>0.4 0.4 0.4</ambient_light>
        <background_color>0.8 0.8 0.8</background_color>
        <camera_pose>-6 0 6 0 0.5 0</camera_pose>
      </plugin>
      <plugin filename="EntityContextMenuPlugin" name="Entity context menu">
        <gz-gui>
          <property key="state" type="string">floating</property>
          <property key="width" type="double">5</property>
          <property key="height" type="double">5</property>
          <property key="showTitleBar" type="bool">false</property>
        </gz-gui>
      </plugin>
      <plugin filename="GzSceneManager" name="Scene Manager">
        <gz-gui>
          <property key="resizable" type="bool">false</property>
          <property key="width" type="double">5</property>
          <property key="height" type="double">5</property>
          <property key="state" type="string">floating</property>
          <property key="showTitleBar" type="bool">false</property>
        </gz-gui>
      </plugin>
      <plugin filename="InteractiveViewControl" name="Interactive view control">
        <gz-gui>
          <property key="resizable" type="bool">false</property>
          <property key="width" type="double">5</property>
          <property key="height" type="double">5</property>
          <property key="state" type="string">floating</property>
          <property key="showTitleBar" type="bool">false</property>
        </gz-gui>
      </plugin>
      <plugin filename="CameraTracking" name="Camera Tracking">
        <gz-gui>
          <property key="resizable" type="bool">false</property>
          <property key="width" type="double">5</property>
          <property key="height" type="double">5</property>
          <property key="state" type="string">floating</property>
          <property key="showTitleBar" type="bool">false</property>
        </gz-gui>
      </plugin>
      <!-- World control -->
      <plugin filename="WorldControl" name="World control">
        <gz-gui>
          <title>World control</title>
          <property type="bool" key="showTitleBar">false</property>
          <property type="bool" key="resizable">false</property>
          <property type="double" key="height">72</property>
          <property type="double" key="z">1</property>

          <property type="string" key="state">floating</property>
          <anchors target="3D View">
            <line own="left" target="left"/>
            <line own="bottom" target="bottom"/>
          </anchors>
        </gz-gui>

        <play_pause>true</play_pause>
        <step>true</step>
        <start_paused>true</start_paused>
        <use_event>true</use_event>
        </plugin>
      <plugin filename="WorldStats" name="World stats">
        <gz-gui>
          <title>World stats</title>
          <property type="bool" key="showTitleBar">false</property>
          <property type="bool" key="resizable">false</property>
          <property type="double" key="height">110</property>
          <property type="double" key="width">290</property>
          <property type="double" key="z">1</property>

          <property type="string" key="state">floating</property>
          <anchors target="3D View">
            <line own="right" target="right"/>
            <line own="bottom" target="bottom"/>
          </anchors>
        </gz-gui>

        <sim_time>true</sim_time>
        <real_time>true</real_time>
        <real_time_factor>true</real_time_factor>
        <iterations>true</iterations>
      </plugin>



      <plugin filename="VisualizeLidar" name="Visualize Lidar">
        </plugin>

      <plugin filename="ComponentInspector" name="Component inspector">
        <gz-gui>
          <property type="string" key="state">docked</property>
        </gz-gui>
      </plugin>

      <!-- Entity tree -->
      <plugin filename="EntityTree" name="Entity tree">
        <gz-gui>
          <property type="string" key="state">docked</property>
        </gz-gui>
      </plugin>

      <plugin filename="ImageDisplay"name="Image Display">
        <gz-gui>
        </gz-gui>
        <topic>/panoptic/labels_map</topic>
      </plugin>

  </gui>

    <light type="directional" name="sun">
      <cast_shadows>true</cast_shadows>
      <pose>0 0 10 0 0 0</pose>
      <diffuse>0.8 0.8 0.8 1</diffuse>
      <specular>0.2 0.2 0.2 1</specular>
      <attenuation>
        <range>1000</range>
        <constant>0.9</constant>
        <linear>0.01</linear>
        <quadratic>0.001</quadratic>
      </attenuation>
      <direction>-0.5 0.1 -0.9</direction>
    </light>

    <model name="ground_plane">
      <static>1</static>
      <link name="link">
        <collision name="collision">
          <geometry>
            <plane>
              <normal>0 0 1</normal>
              <size>100 100</size>
            </plane>
          </geometry>
        </collision>
        <visual name="visual">
          <geometry>
            <plane>
              <normal>0 0 1</normal>
              <size>100 100</size>
            </plane>
          </geometry>
          <material>
            <ambient>0.8 0.8 0.8 1</ambient>
            <diffuse>0.8 0.8 0.8 1</diffuse>
            <specular>0.8 0.8 0.8 1</specular>
          </material>
          </visual>
          </link>
      </model>

    <model name="conveyor">
<!--            <pose>0 0 0 0 0 -1.0</pose>-->
            <static>1</static>
            <link name='base_link'>
                <pose relative_to='__model__'>0 0 1.05 0 0 1.573</pose>
                <inertial>
                    <mass>6.06</mass>
                    <inertia>
                        <ixx>0.002731</ixx>
                        <ixy>0</ixy>
                        <ixz>0</ixz>
                        <iyy>0.032554</iyy>
                        <iyz>1.5e-05</iyz>
                        <izz>0.031391</izz>
                    </inertia>
                </inertial>
                <collision name='main_collision'>
                    <pose relative_to='base_link'>0 0 0 0 0 0</pose>
                    <geometry>
                        <box>
                            <size>5 0.2 0.1</size>
                        </box>
                    </geometry>
                    <surface>
                        <friction>
                            <ode>
                                <mu>0.7</mu>
                                <mu2>150</mu2>
                                <fdir1>0 1 0</fdir1>
                            </ode>
                        </friction>
                    </surface>
                </collision>
                <collision name='collision_1'>
                    <pose relative_to='base_link'>2.5 0 0 -1.570796327 0 0</pose>
                    <geometry>
                        <cylinder>
                            <length>0.2</length>
                            <radius>0.05</radius>
                        </cylinder>
                    </geometry>
                    <surface>
                        <friction>
                            <ode>
                                <mu>0.7</mu>
                                <mu2>150</mu2>
                                <fdir1>0 1 0</fdir1>
                            </ode>
                        </friction>
                    </surface>
                </collision>
                <collision name='collision_2'>
                    <pose relative_to='base_link'>-2.5 0 0 -1.570796327 0 0</pose>
                    <geometry>
                        <cylinder>
                            <length>0.2</length>
                            <radius>0.05</radius>
                        </cylinder>
                    </geometry>
                    <surface>
                        <friction>
                            <ode>
                                <mu>0.7</mu>
                                <mu2>150</mu2>
                                <fdir1>0 1 0</fdir1>
                            </ode>
                        </friction>
                    </surface>
                </collision>
                <visual name='main_visual'>
                    <pose relative_to='base_link'>0 0 0 0 0 0</pose>
                    <geometry>
                        <box>
                            <size>5 0.2 0.1</size>
                        </box>
                    </geometry>
                    <material>
                        <ambient>0.05 0.05 0.70 1</ambient>
                        <diffuse>0.05 0.05 0.70 1</diffuse>
                        <specular>0.8 0.8 0.8 1</specular>
                    </material>
                </visual>
                <visual name='visual_1'>
                    <pose relative_to='base_link'>2.5 0 0 -1.570796327 0 0</pose>
                    <geometry>
                        <cylinder>
                            <length>0.2</length>
                            <radius>0.05</radius>
                        </cylinder>
                    </geometry>
                    <material>
                        <ambient>0.05 0.05 0.70 1</ambient>
                        <diffuse>0.05 0.05 0.70 1</diffuse>
                        <specular>0.8 0.8 0.8 1</specular>
                    </material>
                </visual>
                <visual name='visual_2'>
                    <pose relative_to='base_link'>-2.5 0 0 -1.570796327 0 0</pose>
                    <geometry>
                        <cylinder>
                            <length>0.2</length>
                            <radius>0.05</radius>
                        </cylinder>
                    </geometry>
                    <material>
                        <ambient>0.05 0.05 0.70 1</ambient>
                        <diffuse>0.05 0.05 0.70 1</diffuse>
                        <specular>0.8 0.8 0.8 1</specular>
                    </material>
                </visual>
                <gravity>1</gravity>
                <kinematic>0</kinematic>
            </link>

            <plugin filename="gz-sim-track-controller-system"
                    name="gz::sim::systems::TrackController">
                <link>base_link</link>
                <odometry_publish_frequency>1</odometry_publish_frequency>
                <!--debug>true</debug-->
            </plugin>

            <!-- Moving Forward: W -->
            <plugin filename="gz-sim-triggered-publisher-system"
                    name="gz::sim::systems::TriggeredPublisher">
                <input type="gz.msgs.Int32" topic="/keyboard/keypress">
                    <match field="data">87</match>
                </input>
                <output type="gz.msgs.Double" topic="/model/conveyor/link/base_link/track_cmd_vel">
                    data: 1.0
                </output>
            </plugin>

            <!-- Moving Backward: X -->
            <plugin filename="gz-sim-triggered-publisher-system"
                    name="gz::sim::systems::TriggeredPublisher">
                <input type="gz.msgs.Int32" topic="/keyboard/keypress">
                    <match field="data">88</match>
                </input>
                <output type="gz.msgs.Double" topic="/model/conveyor/link/base_link/track_cmd_vel">
                    data: -1.0
                </output>
            </plugin>

            <!-- Stop: S -->
            <plugin filename="gz-sim-triggered-publisher-system"
                    name="gz::sim::systems::TriggeredPublisher">
                <input type="gz.msgs.Int32" topic="/keyboard/keypress">
                    <match field="data">83</match>
                </input>
                <output type="gz.msgs.Double" topic="/model/conveyor/link/base_link/track_cmd_vel">
                    data: 0.0
                </output>
            </plugin>
      </model>


    <model name="1d_laser_sensor">
      <static>1</static>
      <pose relative_to="conveyor">0.2 0.2 1.15 0 0 3.14</pose>
      <link name="laser_box_link">
        <visual name='main_visual'>
          <geometry>
            <box>
              <size>0.1 0.1 0.1</size>
            </box>
          </geometry>
          <material>
            <ambient>0.8 0.85 0.80 1</ambient>
            <diffuse>0.85 0.85 0.80 1</diffuse>
            <specular>0.8 0.8 0.8 1</specular>
            </material>
        </visual>
      <sensor name="laser" type="gpu_lidar">
        <pose relative_to="laser_box_link">0 0 0 0 0 0</pose>
        <topic>conveyor_laser</topic>
        <update_rate>100</update_rate>
        <ray>
          <scan>
            <horizontal>
                <samples>1</samples>
                <resolution>1</resolution>
                <min_angle>0</min_angle>
                <max_angle>0.01</max_angle>
            </horizontal>
            <vertical>
                <samples>1</samples>
                <resolution>0.01</resolution>
                <min_angle>0</min_angle>
                <max_angle>0</max_angle>
            </vertical>
          </scan>
          <range>
            <min>0.08</min>
            <max>10.0</max>
            <resolution>0.01</resolution>
          </range>
        </ray>
        <always_on>1</always_on>
        <visualize>true</visualize>
      </sensor>
      </link>
    </model>
    <% number_of_items = Random.rand(7..12)%>
     <%for a in 1..number_of_items do%>
     <model name="object<%a%>">
        <pose> 0 0 0 0 0 0</pose>
        <link name="body">
          <visual>
            <geometry>
              <cylinder>
              <length><%Random.rand(0.04..0.14)%></length>
              <radius><%Random.rand(0.021..0.031)%></radius>
              </cylinider>
              <%color=Random.rand(1.0..2.0)%>
              <material>
                <$ if color > 1.5 $>
                   <ambient>1 0 0 1</ambient>
                  <diffuse>1 0 0 1</diffuse>
                  <specular>1 0 0 1</specular>
              <% else %>
                <ambient>0 1 0 1</ambient>
                <diffuse>0 1 0 1</diffuse>
                <specular>0 1 0 1</specular>

              <% end %>
              </material>
                <diffuse
              </materail>
            </geometry>

          </visual>
          <collision>

          </collision>
        </link>
      </model>
    <% end %>

         <include>
      <uri>https://fuel.gazebosim.org/1.0/OpenRobotics/models/Table</uri>
          <static>true</static>
        </include>
	<include>
	    <pose>0.3 0.9 0 0 0 1.5715</pose>
	    <uri>https://fuel.gazebosim.org/1.0/OpenRobotics/models/TrashBin</uri>
        </include>
      <include>
          <uri> https://fuel.gazebosim.org/1.0/Hcl/models/April Tag 1 </uri>
          <pose>.15 0.9 0.3  0 1.5715 0</pose>
          <size>.1 .1 .1</size>
      </include>      
       
      <include>
	  <pose>-5.3 1.30 0 0 0 0</pose>
	  <uri>https://fuel.gazebosim.org/1.0/OpenRobotics/models/TrashBin</uri>
      <name>recycling</name>
      <plugin filename="gz-sim-label-system" name="gz::sim::systems::Label">
        <label>3</label>
      </plugin>
      </include>

      <include>
	<pose>0.2 .1 2.1 0 0 0</pose>
        <uri>https://fuel.gazebosim.org/1.0/OpenRobotics/models/Coke Can</uri>
        <plugin filename="gz-sim-label-system" name="gz::sim::systems::Label">
          <label>1</label>
        </plugin>
      </include>
      <include>
        <uri>https://fuel.gazebosim.org/1.0/GoogleResearch/models/Vans_Cereal_Honey_Nut_Crunch_11_oz_box</uri>
	<pose>0.6 0.1 2.1 0 0 0</pose>
      </include>
    </world>
</sdf>
