$controller = PagesController.new
$content_dir = "./pukiwiki/content"
$file_dir="./pukiwiki/static"
$storage_dir="./storage/files"
$abs_storage_dir=Dir.pwd+$storage_dir[1,$storage_dir.size-1]
$group=nil
$user=User.find(1)
puts $abs_storage_dir
$err=""
$err_f=[]
def migrate_pukiwiki
  readdir $content_dir
  readfiledir $file_dir
  puts $err_f
  File.open("./pukiwiki_migrate.log","w") do |file|
      file.puts $err +"\n"
  end
end
def readdir dir_str
  #dir = Dir.open(dir_str)
  Dir.children(dir_str).each do |child|
    child_path = dir_str+"/"+child
    if FileTest.directory? child_path
      readdir child_path
    elsif FileTest.file? child_path
      readcontent child_path
    end
  end
  return nil
end
def readcontent path
  path_= path[$content_dir.length, path.length]
  path_=path_.split("/")
  path_.pop
  path_ = path_.join("/").gsub(/\./,"_")
  path_ = path_.gsub(".","_").gsub("?","_").gsub(" ","_").gsub("　","_")
  path__ = $controller.get_formal_path path_
  title = $controller.get_title path__
  str=File.open(path).read
  begin
    page=Page.find_by(path:path__)
    if page==nil
      parent = getparent path__
      Page.create(readable_group:$group,editable_group:$group,parent:parent,title:title,user:$user,content:str,path:path__,is_draft:false,is_public:false)
    else
       page.update(content:str,readable_group_id:$group_id,editable_group_id:$group_id)
    end
  rescue => e
    puts e
    $err_f += [path_]
    $err +=e.to_s+"\n"
  end
end
def readfiledir dir_str
  #dir = Dir.open(dir_str)
  Dir.children(dir_str).each do |child|
    child_path = dir_str+"/"+child
    if FileTest.directory? child_path
      readfiledir child_path
    elsif FileTest.file? child_path
      readfile child_path
    end
  end
  return nil
end
def getparent path
  parent_path = $controller.get_parent_path path
  parent_title = $controller.get_title parent_path
  if parent_path == nil
    return
  end
  parent = Page.find_by(path:parent_path)
  if parent == nil
    parent_pa = getparent(parent_path)
    parent=Page.create(content:"",readable_group:$group,editable_group:$group,parent:parent_pa,title:parent_title,path:parent_path,content:"",is_draft:false,is_public:false,user:$user)
      
  end
  return parent
end
def readfile path
  path_= path[$file_dir.length, path.length]
  path_=path_.split("/")
  file_name=path_.pop
  if !file_name.include?(".")
    file_name+=".txt"
  end
  path_ = path_.join("/")
  path_ = path_.gsub(".","_").gsub("?","_").gsub(" ","_").gsub("　","_")
  path_= $controller.get_formal_path path_
  title = $controller.get_title path_

  #str=File.open(path).read
  begin
    page =Page.find_by(path:path_)
    if(page==nil)
      parent = getparent path_
      page=Page.create(path:path_,readable_group:$group,editable_group:$group,parent:parent,title:title,content:"",user:$user)
    end
    #FileUtils.mkpath($storage_dir+path_)
    #FileUtils.cp_r(path,$storage_dir+path_+"/"+file_name)
    file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:file_name})
    if file != nil
      file.purge
    end
    page.files.attach(io:File.open(path), filename:file_name)
    #if( true||page.uploadfiles.find_by(file_name:file_name)==nil)
      #file = Uploadfile.create(file_name:file_name,file_path:$abs_storage_dir+path_+"/"+file_name)
      #puts $storage_dir+path_+"/"+file_name
      #page.uploadfiles<<file
    #end
  rescue => e
    puts e
    $err_f += [path_,path__,path___]
    $err +=e.to_s+"\n\n"
  end
end
