# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

#
# Setup the Tour info with the above description and instructions.
#
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,"rec")
request.addTour(tour)

prefixForIP = "192.168.1."

link = request.LAN("lan")

COMPUTE_NODE_COUNT = 2

for i in range(COMPUTE_NODE_COUNT + 1):
  if i == 0:
    node = request.XenVM("nfs")
    node.cores = 4
    node.ram = 8192
    bs = node.Blockstore("bs", "/nfs")
    bs.size = "500GB"
    node.routable_control_ip = "true"
    iface = node.addInterface("if" + str(i))
    iface.component_id = "eth1"
    iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
    link.addInterface(iface)
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfs_server.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfs_server.sh"))
  else:
    node = request.XenVM("compute-" + str(i))
    node.cores = 4
    node.ram = 8192
    node.routable_control_ip = "true"
    iface = node.addInterface("if" + str(i))
    iface.component_id = "eth1"
    iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
    link.addInterface(iface)
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/nfs_client.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/nfs_client.sh " + str(i-1) + " " + str(COMPUTE_NODE_COUNT)))
  
