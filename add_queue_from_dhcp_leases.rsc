
     :local net 10.100.1.0/24; # Будет добавлять очереди из этого диапозона. 
     :local iparray; # Массив уже существующих очередей
     /queue simple 
     :foreach i in=[find] do={
      :local ipstr [:tostr [get $i target]]; 
      :local ipaddr;
      :set $ipaddr [:toip [:pick $ipstr 0 ([:len $ipstr] - 3)]]
      :if ( $ipaddr in $net ) do={
        :set iparray ($iparray , $ipaddr)
      }
     };          

     /ip dhcp-server lease
     :foreach i in=[find] do={
       :local ipaddr [:toip [:tostr [get $i active-address]]];       
       :if (($ipaddr in $net) && ([:typeof ([:find $iparray $ipaddr -1])] = "nil")) do={
        /queue simple 
        add name=("user_" . $ipaddr) max-limit=2M/512K target=($ipaddr) total-max-limit=5M
         }       
     };
