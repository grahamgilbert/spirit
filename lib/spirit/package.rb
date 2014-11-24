module Spirit

  class Package

    class << self
      attr_accessor :path

      # Get all packages in the root or given subdir
      def all_dict(subdir='')
        packages_dir = File.join(@path, subdir)
        package_list = {}

        Dir.foreach(packages_dir) do |entry|
          full_path = File.join(packages_dir, entry)

          next if entry =~ /^\./

          package_list[entry] = {
              'name' => entry,
              'path' => full_path
          }

          if File.directory? full_path

            children = Dir.entries(full_path).reject do |name|
              name[0] == '.' || File.exists?(File.join(full_path, name))
            end

            stats = File.lstat(full_path)

            package_list[entry]['items'] = children.count
            package_list[entry]['size'] = 0 # File.size(full_path)
          end
        end

        package_list
      end

      # Get all package sets (basically just directories)
      # Take care not to enumerate bundles as package sets
      def sets
        sets = {}

        Dir.foreach(@path) do |entry|
          full_path = File.join(@path, entry)

          next if entry =~ /^\./
          next unless File.directory? full_path
          next if Dir.exists? File.join(full_path, 'Contents') # Exclude bundles

          children = Dir.entries(full_path).reject do |name|
            name[0] == '.'
          end

          stats = File.lstat(full_path)

          sets[entry] = {
              'items' => children.count,
              'name' => entry,
              'path' => File.join(@path, entry),
              'size' => 0, #File.size(File.join(@path, entry))
          }
        end

        sets
      end

      # Delete a package (optionally from inside a set)
      def delete(package, set=nil)
        package_path = @path.to_s
        package_path << set unless set.nil?
        package_path << package

        File.unlink(File.join(*package_path))
      end

      # Create a new blank package set
      def create_set
        x = 1
        while Dir.exists?(File.join(@path, "Packages Set %d" % x)) do
          x = x.next
        end

        package_set = File.join(@path, "Packages Set %d" % x)
        Dir.mkdir(package_set)
      end

      # Rename a package set (usually a directory)
      def rename_set(from, to)
        original_name = File.join(@path, from)
        new_name = File.join(@path, to)

        File.rename(original_name, new_name)
      end
    end

  end
end