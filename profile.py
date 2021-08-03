# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()
request = pc.makeRequestRSpec()
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,"experiment")
request.addTour(tour)
request.addTour(tour)

prefixForIP = "192.168.1."

link = request.LAN("lan")

for i in range(15):
    node = request.XenVM("compute-" + str(i))
    node.cores = 8
    node.ram = 16384

    iface = node.addInterface("if" + str(i))
    iface.component_id = "eth1"
    iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
    link.addInterface(iface)

pc.printRequestRSpec(request)
