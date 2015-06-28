/*
 * Name: Shashank Singh
 * Andrew ID: sss1
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "mm.h"
#include "memlib.h"

/* If you want debugging output, use the following macro.  When you hand
 * in, remove the #define DEBUG line. */
#define DEBUG
#ifdef DEBUG
# define dbg_printf(...) printf(__VA_ARGS__)
#else
# define dbg_printf(...)
#endif


/* do not change the following! */
#ifdef DRIVER
/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#endif /* def DRIVER */

/* single word (4) or double word (8) alignment */
#define ALIGNMENT   8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(p)    (((size_t)(p) + (ALIGNMENT-1)) & ~0x7)

/* Basic constants and macros - adapted from CS:APP */
#define WSIZE               4       /* Word and header/footer size (bytes) */
#define DSIZE               8       /* Double word size (bytes) */
#define CHUNKSIZE           (1<<12) /* Extend the heap by this much */

#define MIN(x,y)            ((x) < (y) ? (x) : (y)
#define MAX(x,y)            ((x) > (y) ? (x) : (y)

/* Pack a size and allocated bit into a word */
#define PACK(size,alloc)    ((size) | (alloc))

/* Read/write a word at address p */
#define GET(p)              (*(unsigned int *)(p))
#define PUT(p,val)          (*(unsigned int *)(p) = (val))

/* Read the size and allocated fields from address p */
#define GET_SIZE(p)         (GET(p) & ~0x7)
#define GET_ALLOC(p)        (GET(p) & 0x1)

/* Compute header and footer addresses of a given a block pointer bp*/
#define HDRP(bp)            ((char *)(bp) - WSIZE)
#define FTRP(bp)            ((char *)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

/* Compute next and previous block addresses of a given block pointer bp */

#define NEXT_BLKP(bp)       ((char *)(bp) + GET_SIZE(((char *)(bp) - WSIZE)))
#define PREV_BLKP(bp)       ((char *)(bp) - GET_SIZE(((char *)(bp) + DSIZE)))

static char *heap_listp;


/*  ------
 * Initialize: return -1 on error, 0 on success.
 */
int mm_init(void)
{
    /* Create the initial empty heap */
    if((heap_listp = mem_sbrk(4*WSIZE)) == (void *)-1)
        return -1;
    PUT(heap_listp, 0);                             /* Alignment padding */
    PUT(heap_listp + (1*WSIZE), PACK(DSIZE, 1));    /* Prologue header */
    PUT(heap_listp + (2*WSIZE), PACK(DSIZE, 1));    /* Prologue footer */
    PUT(heap_listp + (3*WSIZE), PACK(0, 1));        /* Epilogue header */

    /* Extend the heap with a free block of CHUNKSIZE bytes */
    if(extend_heap(CHUNKSIZE/WSIZE) == NULL)
        return -1;
    return 0;
}

static void *extend_heap(size_t words)
{
    char *bp;
    size_t size;

    /* Allocate an even number of words to maintain alignment */
    size = (words % 2) ? (words+1)*WSIZE : words*WSIZE;
    if((long)(bp = mem_sbrk(size)) == -1)
        return NULL;

    /* Initialize free block header/footer and epilogue header */
    PUT(HDRP(bp), PACK(size,0));            /* Free block header */
    PUT(FTRP(bp), PACK(size,0));            /* Free block footer */
    PUT(HDRP(NEXT_BLKP(bp)), PACK(0,1));    /* New epilogue header */

    /* Coalesce if previous block was free */
    return coalesce(bp);
}

/*
 * malloc
 */
void *malloc (size_t size)
{
    size_t asize; /* adjusted block size */
    size_t extendsize; /* Amount to extend the heap if no fit */
    char *bp;

    /* Ignore spurious requests */
    if(size == 0)
        return NULL;

    /* Adjust block size to account for overhead and alignment */
    if(size <= DSIZE)
        asize = 2*DSIZE;
    else
        asize = DSIZE * ((size + (DSIZE) + (DSIZE - 1))/DSIZE);

    /* Search the free list for a fit */
    if((bp = find_fit(asize)) != NULL)
    {
        place(bp, asize);
        return bp;
    }

    /* No fit found */
    extendsize = MAX(asize,CHUNKSIZE);
    if((bp = extend_heap(extendsize/WSIZE)) == NULL)
        return NULL;
    place(bp,asize);
    return bp;
}

/* helper function for malloc which performs a first-fit search of the
 * implicit free list
 */
static void *find_fit(size_t asize)
{
    char *bp = heap_listp + WSIZE; /* body of the first block */
    while(GET_SIZE(HDRP(bp)) != 0)
    {
        if(GET_SIZE(HDRP(bp)) >= asize && !GET_ALLOC(HDRP(bp)))
            return bp;
        bp = NEXT_BKLP(bp);
    }

    return NULL; /* no sufficiently large block found */
}

/* helper function for malloc which places the header and footer for the
 * newly allocated block, as well as for the remainder of the block if it
 * was split (we split unless the remainder would be too small to use)
 */
static void place(void *bp, size_t size)
{
    size_t space_size = GET_SIZE(HDRP(bp));
    /* Check whether leftover block is smaller than min block size */
    if(GET_SIZE(HDRP(bp)) - size < DSIZE)
    {
        PUT(HDRP(bp),PACK(GET_SIZE(HDRP(bp),1)));
        PUT(FTRP(bp),PACK(GET_SIZE(HDRP(bp),1)));
    }
    else /* We need to split */
    {
        PUT(HDRP(bp),PACK(size,1));
        PUT(FTRP(bp),PACK(size,1));
        PUT(HDRP(NEXT_BLKP(bp)),PACK(space_size - size,0));
        PUT(FTRP(NEXT_BLKP(bp)),PACK(space_size - size,0));
    }
}

/*
 * free
 */
void free (void *ptr)
{
    size_t size = GET_SIZE(HDRP(ptr));

    PUT(HDRP(ptr), PACK(size, 0));
    PUT(FTRP(ptr), PACK(size, 0));
    coalesce(bp);
}

/* Helper function for free which checks whether a free'd block should be
 * coalesced with its neighbors (4 cases, based on whether its neighbors are
 * free), and performs the coalescing if necessary
 */
static void *coalesce(void *bp)
{
    size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp)));
    size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    size_t size = GET_SIZE(HDRP(bp));

    if(prev_alloc && next_alloc)
        return bp;

    else if(prev_alloc && !next_alloc)
    {
        size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(bp), PACK(size,0));
        PUT(FTRP(bp), PACK(size,0));
    }
    else if(!prev_alloc && next_alloc)
    {
        size += GET_SIZE(HDRP(PREV_BLKP(bp)));
        PUT(HDRP(PREV_BKLP(bp)), PACK(size,0));
        PUT(FTRP(bp), PACK(size,0));
        bp = PREV_BLKP(bp);
    }
    else
    {
        size += GET_SIZE(HDRP(NEXT_BLKP(bp))) +
                GET_SIZE(HDRP(PREV_BLKP(bp)));
        PUT(HDRP(PREV_BKLP(bp)), PACK(size,0));
        PUT(FTRP(NEXT_BLKP(bp)), PACK(size,0));
        bp = PREV_BLKP(bp);
    }
    return bp;
}

/*
 * realloc - you may want to look at mm-naive.c
 */
void *realloc(void *oldptr, size_t size)
{
    return NULL;
}

/*
 * calloc - Allocate the block and set it to zero.
 * You may want to look at mm-naive.c
 * This function is not tested by mdriver, but it is
 * needed to run the traces.
 */
void *calloc (size_t nmemb, size_t size)
{
  size_t bytes = nmemb * size;
  void *newptr;

  newptr = malloc(bytes);
  memset(newptr, 0, bytes);

  return newptr;
}


/*
 * Return whether the pointer is in the heap.
 * May be useful for debugging.
 */
static int in_heap(const void *p) {
    return p <= mem_heap_hi() && p >= mem_heap_lo();
}

/*
 * Return whether the pointer is aligned.
 * May be useful for debugging.
 */
static int aligned(const void *p) {
    return (size_t)ALIGN(p) == (size_t)p;
}

/*
 * mm_checkheap
 */
void mm_checkheap(int verbose) {
}
