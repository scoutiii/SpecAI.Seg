load_all()
library(SpecAI.Seg)

ip <- get_data("indianpines")
seg <- watershed_hsi(ip)
relabel_seg(seg)

test_mat <- matrix(c(1,1,0, 1,0,0, 0,1,1), nrow=3)
test_mat <- seg
relabel_seg(test_mat)

new_seg <- matrix(0, nrow(seg), ncol(seg))
new_seg[1, 1] <- 1
next_lab <- 2

for (r in seq_len(nrow(seg))) {
  for (c in seq_len(ncol(seg))) {
    if (new_seg[r, c] == 0) {
      if (r-1 > 0 && test_mat[r-1, c] == test_mat[r, c] && new_seg[r-1, c] != 0) {
          new_seg[r, c] <- new_seg[r-1, c]
      } else if (r + 1 <= 3 && test_mat[r+1, c] == test_mat[r, c] && new_seg[r+1, c] != 0) {
        new_seg[r, c] <- new_seg[r+1, c]
      } else if (c - 1 > 0 && test_mat[r, c-1] == test_mat[r, c] && new_seg[r, c-1] != 0) {
        new_seg[r, c] <- new_seg[r, c-1]
      } else if (c + 1 <= 3 && test_mat[r, c+1] == test_mat[r, c] && new_seg[r, c+1] != 0) {
        new_seg[r, c] <- new_seg[r, c+1]
      } else {
        new_seg[r, c] <- next_lab
        next_lab <- next_lab + 1
      }
    }

    if (r-1 > 0 && test_mat[r-1, c] == test_mat[r, c] && new_seg[r-1, c] == 0) {
      new_seg[r-1, c] = new_seg[r, c]
    }
    if (r+1 <= 3 && test_mat[r+1, c] == test_mat[r, c] && new_seg[r+1, c] == 0) {
      new_seg[r+1, c] = new_seg[r, c]
    }
    if (c-1 > 0 && test_mat[r, c-1] == test_mat[r, c] && new_seg[r, c-1] == 0) {
      new_seg[r, c-1] = new_seg[r, c]
    }
    if (c+1 <= 3 && test_mat[r, c+1] == test_mat[r, c] && new_seg[r, c+1] == 0) {
      new_seg[r, c+1] = new_seg[r, c]
    }
  }
}
new_seg
