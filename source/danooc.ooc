import io/File
import text/StringTokenizer
import structs/[HashMap, ArrayList, List]
import os/[Env, System, Process, Terminal]


min: func(i: Int, j: Int) -> Int {
  if (i < j) return i
  else return j
}

max: func(ls: List<Int>) -> Int {
  m := ls[0]
  for (el in ls) {
    if (el > m) m = el
  }
  return m
}

rightPad: func(s: String, reach: Int) -> String {
  len := s length()
  new_str := s
  if (reach < len) return s
  else for (i in 0..(reach-len)) new_str += " "
  return new_str
}

printMessage: func(msg: String) {
  Terminal setFgColor(Color green)
  "\n#{msg}\n" println()
  Terminal reset()
}

printOverall: func(f2s: HashMap<String, Int>, overall_size: Int) {
  println()
  "> Total #{f2s size} files found." println()
  "> Size %d KB, or ~%.2f MB, or ~%.2f GB" \
  printfln(overall_size, overall_size*1.0/1024, overall_size*1.0/1024/1024)
  println()
}

printVisualizationBar: func(items: Int) {
  "{ " print()
  for (t in 0..items) {
    "#" print()
  }
  " }" print()
  println()
}

getFileExtension: func(path: String) -> String {
  name := path split("/") last()
  if (name contains?("."))
    return name reverse() split(".", 2) [0] reverse() trim() toLower()
  else 
    return "empty"
}

addHashMapValues: func(h: HashMap <String, Int>) -> Int {
  s := 0
  h each(|key, value| s += value)
  return s
}

recurseDirectory: func(path: File, hash: HashMap <String, Int>) -> HashMap<String, Int> {
  File new(path) getChildren() each(|f|
    if (f dir?()) recurseDirectory(f, hash)
    else hash put(f getPath(), f getSize() / 1024)
  )
  return hash
}

filesToSizeMap: func(args: String[]) -> HashMap <String, Int> {   
  hash := HashMap <String, Int> new()
  if (args length > 1 && File new(args[1]) dir?()) {
    printMessage("> Running for: " + args[1])
    return recurseDirectory(File new(args[1]), hash)
  }
  else {
    printMessage("> Running for the current directory.")
    return recurseDirectory(File new(File getCwd()), hash)  
  }
}

swap : func <T> (arr: ArrayList<T>, a: Int, b: Int) {
  temp := arr[a]
  arr[a] = arr[b]
  arr[b] = temp
}

quicksort: func(arr: ArrayList<Int>, ar2: ArrayList<String>, l: Int, r: Int) {
  i := l + 1  
  if (l < r) {
    piv := arr[l]
    for(j in (l+1)..r) {
      if (arr[j] > piv) {
        swap(arr, i, j)
        swap(ar2, i, j)
        i += 1
      }
    }
    swap(arr, l, i-1)
    swap(ar2, l, i-1)
    quicksort(arr, ar2, l, i-1)
    quicksort(arr, ar2, i, r)
  }
}


main: func (args: String[]) -> Int {
  // A map {"file_path" -> size}
  f2s := filesToSizeMap(args)

  if (f2s size == 0) {
    Terminal setFgColor(Color red)
    "! Directory empty. Quiting." println()
    Terminal reset()
    println()
    return 0
  }

  // Get the overall size by adding the HashMap values
  overall_size := addHashMapValues(f2s)

  // A HashMap to keep the different extensions
  extensions := HashMap <String, Int> new()

  // Search in f2s and find all the different
  // extensions and map them to their overall
  // added size. Keep them in 'extensions'
  f2s each(|key, value|
    ext := getFileExtension(key)
    if (! extensions contains?(ext)) {
      extensions put(ext, value)
    }
    else {
      temp := extensions get(ext)
      extensions put(ext, value + temp)
    }
  )
  
  // Get extensions keys as an ArrayList
  ext_ar := extensions getKeys()

  // Get the extensions values (sizes) as an ArrayList
  bts_ar := ArrayList<Int> new()
  ext_ar each(|item|
    bts_ar add(extensions get(item))
  )

  // Sort them both with respect to values 
  quicksort(bts_ar, ext_ar, 0, bts_ar size)

  // Find the max length of the extensions
  // that we have found know how much to pad
  // when giving the output
  pad_len := max(ext_ar map(|el| el length()))


  // Define some colors to print and visualize the
  // size better
  colors := [Color red, Color blue, Color magenta, \
              Color green, Color yellow, Color cyan ]

  // We will visualize at most 6 extensions,
  // but maybe the colors are more than the
  // extensions found, so check if this is true
  visualized := min(6, bts_ar size as Int)

  // A counter to know in which we are using
  visualized_c := 0

  // Print everything
  for(i in 0 .. bts_ar size) {
    s := bts_ar[i]
    percent := s*100.0/overall_size
    if (visualized_c < visualized) {
        items := percent as Int / 2
        Terminal setFgColor(colors[visualized_c])
        "@ " print()
        Terminal reset()
        ".%s -> %10d KBytes (%5.2f \% ) " printf(rightPad(ext_ar[i], pad_len), s, percent)
        Terminal setFgColor(colors[visualized_c])
        printVisualizationBar(items)
        Terminal reset()
        visualized_c += 1
    }
    else {
        "@ .%s -> %10d KBytes (%5.2f \% )" printfln(rightPad(ext_ar[i], pad_len), s, percent)
    }
  }

  printOverall(f2s, overall_size)

  return 0
}
