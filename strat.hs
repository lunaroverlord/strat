import System.Environment
import System.Random
import Codec.Picture
import Data.List
import Control.Parallel.Strategies
import Control.Concurrent

--Generates a list of n random integers x, where 0 <= x < max
randomList :: Int -> Int -> StdGen -> [Int]
randomList n max = map (\x -> (abs x) `rem` max) . take (n + 1) . unfoldr (Just . random)

--Tests whether a given coordinate at index i from xCoords and yCoords in img is land
coordIsLand :: [Int] -> [Int] -> Image PixelRGB8 -> Int -> Bool
coordIsLand xCoords yCoords img i = land $ pixelAt img (xCoords !! i) (yCoords !! i)
    where
    land (PixelRGB8 r g b) = (r == 248) && (g == 159) && (b == 27)

--Chunked application of a function on a list, like map
--Takes in Int - how many chunks to split in
parMapChunk :: Strategy b -> Int -> (a -> b) -> [a] -> [b]
parMapChunk strat chunkSize f = withStrategy (parListChunk chunkSize strat) . map f

--Main program
main :: IO()
main = do
    [argument1, argument2] <- getArgs
    let samples = read argument1
    let parallel = read argument2
    seed <- newStdGen
    imgFile <- readImage "scotlandmap.png"
    case imgFile of
        Right (ImageRGB8 img@(Image width height _)) ->
            let xCoords = randomList samples width seed
                yCoords = randomList samples height seed
                mapper = if parallel then parMapChunk rdeepseq chunkSize else map
                    where chunkSize = ceiling $ fromIntegral samples / 4
                landList = mapper (coordIsLand xCoords yCoords img) [1..samples]
                hits = length . filter id --counts ones in a list
                positiveSamples = hits landList
            in 
                print $ fromIntegral(positiveSamples) / fromIntegral(samples)
        _ -> print "Unexpected image format"
    
