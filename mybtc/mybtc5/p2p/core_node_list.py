import threading

class CoreNodeList:
  """
  """
  def __init__(self):
    self.lock = threading.Lock()
    self.list = set()

  def add(self, peer):
    """
    param:
      peer :
    """
    with self.lock:
      print('Adding peer: ', peer)
      self.list.add((peer))
      print('Current Core Set: ', self.list)

  def remove(self, peer):
    """
    param:
      peer :
    """
    with self.lock:
      if peer in self.list:
        print('Removing peer: ', peer)
        self.list.remove(peer)
        print('Current Core list: ', self.list)

  def overwrite(self, new_list):
    """
    """
    with self.lock:
      print('core node list will be going to overwrite')
      self.list = new_list
      print('Current Core list: ', self.list)

  def get_list(self):
    """
    """
    return self.list

  def get_c_node_info(self):
    c_list = []
    for i in self.list:
      c_list.append(i)

    return c_list[0]

  def get_length(self):
    return len(self.list)

  def has_this_peer(self, peer):
    """
      param:
        peer :
      return:
        True or False
    """
    return peer in self.list

